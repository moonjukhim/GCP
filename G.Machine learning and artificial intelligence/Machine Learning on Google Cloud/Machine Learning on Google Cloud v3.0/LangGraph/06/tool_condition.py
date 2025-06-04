from typing import Union, Literal
from langchain_core.messages import AnyMessage

def tools_condition(
    state: Union[list[AnyMessage], dict[str, Any]],
    messages_key: str = "messages",
) -> Literal["tools", "__end__"]:
    """조건부 엣지에서 사용되며, 마지막 메시지에 도구 호출이 포함되어 있으면 ToolNode로 라우팅하고,
    포함되어 있지 않으면 종료로 라우팅합니다.

    Args:
        state (Union[list[AnyMessage], dict[str, Any]]): 도구 호출 여부를 확인할 상태. 메시지의 리스트(MessageGraph) 또는 "messages" 키를 가진(StateGraph) 딕셔너리입니다.

    Returns:
        Literal["tools", "__end__"]: 다음에 라우팅할 노드를 나타내는 문자열입니다.
    """
    if isinstance(state, list):
        ai_message = state[-1]
    elif messages := state.get(messages_key, []):
        ai_message = messages[-1]
    else:
        raise ValueError(f"tool_edge의 입력 상태에서 메시지를 찾을 수 없습니다: {state}")

    if hasattr(ai_message, "tool_calls") and len(ai_message.tool_calls) > 0:
        return "tools"
    return "__end__"
