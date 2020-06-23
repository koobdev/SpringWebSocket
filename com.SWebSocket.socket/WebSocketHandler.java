package com.Kcompany.Kboard.socket;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;


//Socket통신은 서버와 클라이언트가 1:N으로 관계를 맺는다. 여러개의 클라이언트가 메세지를 처리해줄 Handler클래스를 정의한다.
@Component
public class WebSocketHandler extends TextWebSocketHandler {
	 
	List<WebSocketSession> sessions = new ArrayList<>();
	
	//연결이 완료되었을 때 - 클라이언트가 연결될 때
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("afterConnectionEstablished : " + session);
		//연결된 세션을 리스트에 모두 담는다. 리스트에는 연결된 모든 세션이 담겨있다.
		sessions.add(session);
	}

	//Handler가 받은 메세지
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("handleTextMessage : " + session + " : " + message);
		// 브로드캐스팅 - 접속된 모든 이용자에게 메세지를 날림
		String senderId = session.getId();
		for(WebSocketSession sess : sessions) {
			sess.sendMessage(new TextMessage(senderId + ":" + message.getPayload()));
		}
	}

	//연결이 끊겼을 때
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// TODO Auto-generated method stub
		System.out.println("afterConnectionClosed : " + session +  " : " + status);
	}
	
	
}
