package com.Kcompany.Kboard.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.Kcompany.Kboard.service.CRoomService;
import com.Kcompany.Kboard.vo.ChatMessage;
import com.Kcompany.Kboard.vo.ChatRoom;
import com.Kcompany.Kboard.vo.MemberVO;

@Controller
public class StompController {

	@Autowired
	private SimpMessageSendingOperations messagingTemplate;
	
	// 채팅방에 참여하고 있는 User의 ID
	List<String> currentUser = new ArrayList<>();
	
	@Autowired
	private CRoomService cRoom_service;

	
	@MessageMapping("/TTT")
	public void message(ChatMessage message) throws Exception {
		
		System.out.println("TTT >> " + message);
		System.out.println("Message >> " + "roomid : " +  message.getRoomId() + 
				",  sender : " + message.getSender() + ",  msg : " + message.getMessage());
		messagingTemplate.convertAndSend("/sub/message/" + message.getRoomId(), message);
	}
	
	
	@MessageMapping("/disConn")
	@SendTo("/sub/message")
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
	public String createChat(ChatRoom chatRoom, HttpServletRequest request) {
		/*HttpSession session = request.getSession();
		MemberVO memSession = (MemberVO) session.getAttribute("member");
		String sessionId = memSession.getMemId();*/
		
		
		List<ChatRoom> list = cRoom_service.getlist();
		for(ChatRoom create : list) {
			if(create.getName().equals(chatRoom.getName())) {
				System.out.println("개설 실패");
				return null;
			}
			else {
				int result = cRoom_service.createRoom(chatRoom);
				if(result != 1) {
					System.out.println("개설 성공");
				}
				else break;
			}
		}
		return "/chat/createOK";
	}
	
	// 채팅방 진입
	@RequestMapping("/chat/{id}")
	public String chat(@PathVariable String id, HttpServletRequest request, Model model) {
		HttpSession session = request.getSession();	
		MemberVO memSession = (MemberVO) session.getAttribute("member");
		String sessionId = memSession.getMemId();
		
		// 채팅방에 참여하고 있는 user를 추가한다.
		currentUser.add(sessionId);
		
		// 채팅방에 참여하고 있는 user를 모델에 담아 보낸다.
		model.addAttribute("userList", currentUser);
		model.addAttribute("roomId", id);
		
		System.out.println("ID >>>>>>>>>" + sessionId);
		
		return "/chat/chat";
	}
}


















