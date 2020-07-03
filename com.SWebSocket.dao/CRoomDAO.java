package com.Kcompany.Kboard.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.Kcompany.Kboard.mapper.CRoomMapper;
import com.Kcompany.Kboard.vo.ChatRoom;

@Repository
public class CRoomDAO {

	@Autowired
	private CRoomMapper mapper;
	
	// 채팅방 리스트 가져오기
	public List<ChatRoom> rootList(){
		return mapper.list(); 
	}
	
	// 채팅방 생성하기
	public int create(ChatRoom chatRoom) {
		return mapper.createRoom(chatRoom);
	}
}
