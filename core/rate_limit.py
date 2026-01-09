"""
Rate limiting utility for password reset endpoints.
Uses in-memory storage to track requests per IP and per email.
"""
from datetime import datetime, timedelta
from typing import Dict, Tuple
from collections import defaultdict
import logging

logger = logging.getLogger(__name__)

# In-memory storage for rate limiting
# Format: {key: [(timestamp1, timestamp2, ...)]}
_rate_limit_store: Dict[str, list] = defaultdict(list)

# Rate limit configuration
RATE_LIMIT_PER_IP = 5  # Max 5 requests per IP per hour
RATE_LIMIT_PER_EMAIL = 3  # Max 3 requests per email per hour
RATE_LIMIT_GLOBAL = 100  # Max 100 requests total across all IPs per hour
RATE_LIMIT_WINDOW_HOURS = 1  # Time window in hours

# Global request tracker (all IPs combined)
_global_requests: list = []


def _cleanup_old_entries(key: str, window_hours: int):
    """Remove entries older than the time window."""
    cutoff_time = datetime.utcnow() - timedelta(hours=window_hours)
    _rate_limit_store[key] = [
        ts for ts in _rate_limit_store[key] if ts > cutoff_time
    ]


def _cleanup_global_requests(window_hours: int):
    """Remove old entries from global request tracker."""
    global _global_requests
    cutoff_time = datetime.utcnow() - timedelta(hours=window_hours)
    _global_requests = [
        ts for ts in _global_requests if ts > cutoff_time
    ]


def check_rate_limit_global() -> Tuple[bool, str]:
    """
    Check if global rate limit (across all IPs) has been exceeded.
    Returns: (is_allowed, message)
    """
    global _global_requests
    _cleanup_global_requests(RATE_LIMIT_WINDOW_HOURS)
    
    request_count = len(_global_requests)
    
    if request_count >= RATE_LIMIT_GLOBAL:
        logger.warning(f"Global rate limit exceeded: {request_count} total requests in the last hour")
        return False, f"Too many password reset requests system-wide. Please try again later."
    
    # Record this request
    _global_requests.append(datetime.utcnow())
    return True, ""


def check_rate_limit_ip(ip_address: str) -> Tuple[bool, str]:
    """
    Check if IP address has exceeded rate limit.
    Returns: (is_allowed, message)
    """
    key = f"ip:{ip_address}"
    _cleanup_old_entries(key, RATE_LIMIT_WINDOW_HOURS)
    
    request_count = len(_rate_limit_store[key])
    
    if request_count >= RATE_LIMIT_PER_IP:
        logger.warning(f"Rate limit exceeded for IP: {ip_address} ({request_count} requests)")
        return False, f"Too many password reset requests. Please try again in {RATE_LIMIT_WINDOW_HOURS} hour(s)."
    
    # Record this request
    _rate_limit_store[key].append(datetime.utcnow())
    return True, ""


def check_rate_limit_email(email: str) -> Tuple[bool, str]:
    """
    Check if email address has exceeded rate limit.
    Returns: (is_allowed, message)
    """
    key = f"email:{email.lower()}"
    _cleanup_old_entries(key, RATE_LIMIT_WINDOW_HOURS)
    
    request_count = len(_rate_limit_store[key])
    
    if request_count >= RATE_LIMIT_PER_EMAIL:
        logger.warning(f"Rate limit exceeded for email: {email} ({request_count} requests)")
        return False, f"Too many password reset requests for this email. Please try again in {RATE_LIMIT_WINDOW_HOURS} hour(s)."
    
    # Record this request
    _rate_limit_store[key].append(datetime.utcnow())
    return True, ""


def check_rate_limit(ip_address: str, email: str) -> Tuple[bool, str]:
    """
    Check global, IP, and email rate limits (in that order).
    Returns: (is_allowed, message)
    """
    # Check global limit first (across all IPs)
    global_allowed, global_message = check_rate_limit_global()
    if not global_allowed:
        return False, global_message
    
    # Check IP limit
    ip_allowed, ip_message = check_rate_limit_ip(ip_address)
    if not ip_allowed:
        return False, ip_message
    
    # Check email limit
    email_allowed, email_message = check_rate_limit_email(email)
    if not email_allowed:
        return False, email_message
    
    return True, ""
