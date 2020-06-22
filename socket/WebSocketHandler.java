package com.Kcompany.Kboard.socket;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

//Socket통신은 서버와 클라이언트가 1:N으로 관계를 맺는다. 여러개의 클라이언트가 메세지를 처리해줄 Handler클래스를 정의한다.
@Component
public class WebSocketHandler extends TextWebSocketHandler {
	 
	//연결이 완료되었을 때 - 클라이언트가 연결될 때
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("afterConnectionEstablished" + session);
	}

	//Handler가 받은 메세지
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
        TextMessage textMessage = new TextMessage("Welcome chatting sever~^^");
        session.sendMessage(textMessage);
	}

	//연결이 끊겼을 때
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("afterConnectionClosed" + session);
	}

}
