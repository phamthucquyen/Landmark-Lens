from fastapi import APIRouter, Query
from schemas.wrapped import WrappedResponse
from services.wrapped_service import build_wrapped

router = APIRouter(prefix="/wrapped", tags=["Wrapped"])

@router.get("/{user_id}", response_model=WrappedResponse)
def get_wrapped(user_id: str, limit: int = Query(50, ge=1, le=200)):
    return build_wrapped(user_id=user_id, limit=limit)
