from pydantic import BaseModel, Field
from typing import List, Optional

class WrappedScanItem(BaseModel):
    landmark_name: str
    tags: List[str] = Field(default_factory=list)
    timestamp: Optional[str] = None

class WrappedResponse(BaseModel):
    total_scans: int
    unique_landmarks: int
    items: List[WrappedScanItem] = Field(default_factory=list)
