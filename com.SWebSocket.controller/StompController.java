package com.Kcompany.Kboard.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Kcompany.Kboard.service.CRoomService;
import com.Kcompany.Kboard.vo.ChatRoom;

@Controller
public class StompController {

	//private final SimpMessagingTemplate messageTemplate = null;
	
	@Autowired
	private CRoomService cRoom_service;
	
	@MessageMapping("/TTT")
	@SendTo("/topic/message")
	public String message(String message) throws Exception {
		System.out.println("Message >> " + message);
		return message;
	}
	
	@MessageMapping("/disConn")
	@SendTo("/topic/message")
	public String disConn(String msg) {
		System.out.println("id : xxxx DISCONNECTED");
		return msg;
	}
	
	// 채팅방 리스트 보여주기
	@RequestMapping("/chatList")
	public String chatList(Model model) {
		
		List<ChatRoom> list = cRoom_service.getlist();
		model.addAttribute("rooms", list);
		return "/chat/chatRoomList";
	}
	
	// 채팅방 생성
	@RequestMapping("/createChat")
	public String createChat(@RequestParam String name) {
		System.out.println(name);
		return null;
	}
	
	// 채팅방 진입
	@RequestMapping("/chat")
	public String chat(@RequestParam String id) {
		return "/chat/chat";
	}
}
