package com.Kcompany.Kboard.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import com.Kcompany.Kboard.vo.ChatRoom;


@Mapper
public interface CRoomMapper {

	@Select("select * from chat")
	List<ChatRoom> list();
	
	@Insert("insert into chat values(#{Room.id},#{Room.name},#{Room.creater})")
	int createRoom(@Param("Room") ChatRoom chatRoom);
	
}
