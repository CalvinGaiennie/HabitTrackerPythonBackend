from typing import Optional
import json

def parse_clock_data(value_text: Optional[str]) -> dict:
    if not value_text:
        return {
            "current_state": "clocked_out",
            "sessions": [],
            "total_duration_minutes": 0,
            "last_updated": None,
        }
    try: 
        data = json.loads(value_text)
        data.setdefault("total_duration_minutes", 0)
        data.setdefault("sessions", [])
        data.setdefault("current_state", "clocked_out")
        return data
    except json.JSONDecodeError:
        return {
            "current_state": "clocked_out",
            "sessions": [],
            "total_duration_minutes": 0,
            "last_updated": None,
        }