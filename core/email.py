import smtplib
import os
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from typing import Optional
import logging

logger = logging.getLogger(__name__)

def send_password_reset_email(email: str, reset_token: str, frontend_url: str = "http://localhost:5173") -> bool:
    """
    Send a password reset email using Gmail SMTP.
    
    Args:
        email: Recipient email address
        reset_token: JWT token for password reset
        frontend_url: Base URL of the frontend application
        
    Returns:
        True if email sent successfully, False otherwise
    """
    # Get email settings from environment variables
    smtp_server = os.getenv("SMTP_SERVER", "smtp.gmail.com")
    smtp_port = int(os.getenv("SMTP_PORT", "587"))
    smtp_username = os.getenv("SMTP_USERNAME", "")
    smtp_password = os.getenv("SMTP_PASSWORD", "")  # Gmail app password
    from_email = os.getenv("FROM_EMAIL", smtp_username)
    
    if not smtp_username or not smtp_password:
        logger.error("SMTP credentials not configured. Set SMTP_USERNAME and SMTP_PASSWORD environment variables.")
        return False
    
    # Create reset link
    reset_link = f"{frontend_url}/reset-password?token={reset_token}"
    
    # Create email message
    msg = MIMEMultipart("alternative")
    msg["Subject"] = "Reset Your Password"
    msg["From"] = from_email
    msg["To"] = email
    
    # Create HTML email body
    html_body = f"""
    <html>
      <body>
        <h2>Password Reset Request</h2>
        <p>You requested to reset your password. Click the link below to reset it:</p>
        <p><a href="{reset_link}" style="background-color: #4CAF50; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; display: inline-block;">Reset Password</a></p>
        <p>Or copy and paste this link into your browser:</p>
        <p style="word-break: break-all;">{reset_link}</p>
        <p>This link will expire in 1 hour.</p>
        <p>If you didn't request this password reset, please ignore this email.</p>
      </body>
    </html>
    """
    
    # Create plain text email body
    text_body = f"""
    Password Reset Request
    
    You requested to reset your password. Click the link below to reset it:
    
    {reset_link}
    
    This link will expire in 1 hour.
    
    If you didn't request this password reset, please ignore this email.
    """
    
    # Attach both HTML and plain text versions
    part1 = MIMEText(text_body, "plain")
    part2 = MIMEText(html_body, "html")
    msg.attach(part1)
    msg.attach(part2)
    
    try:
        # Connect to SMTP server and send email
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()  # Enable encryption
            server.login(smtp_username, smtp_password)
            server.send_message(msg)
        
        logger.info(f"Password reset email sent successfully to {email}")
        return True
    except Exception as e:
        logger.error(f"Failed to send password reset email to {email}: {e}")
        return False
