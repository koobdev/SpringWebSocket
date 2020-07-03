package com.Kcompany.Kboard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.Kcompany.Kboard.dao.CRoomDAO;
import com.Kcompany.Kboard.vo.ChatRoom;

@Service
public class CRoomService {

	@Autowired
	private CRoomDAO dao;
	
	
	// 채팅방 리스트 가져오기
	public List<ChatRoom> getlist() {
		List<ChatRoom> list = dao.rootList();
		return list;
	}
	
	
	// 채팅방 생성하기
	public int createRoom(ChatRoom chatRoom) {
		int result = dao.create(chatRoom); 
		
		if(result != 1) {
			System.out.println("createRoom Error!!!!!!");
		}
		return result;
	}
}









