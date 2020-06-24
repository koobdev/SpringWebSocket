package com.Kcompany.Kboard.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.socket.TextMessage;

@Controller
public class StompController {

	//private final SimpMessagingTemplate messageTemplate = null;
	
	@MessageMapping("/message")
	@SendTo("/sub/message")
	public String message(String message) throws Exception {
		System.out.println("tttttttttttttttt >> " + message);
		return message;
	}
	
}
