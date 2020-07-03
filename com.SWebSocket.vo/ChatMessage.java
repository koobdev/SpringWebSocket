package com.Kcompany.Kboard.vo;

public class ChatMessage {

	private String roomId;
	private String sender;
	private String message;
	
	public final String getRoomId() {
		return roomId;
	}
	public final void setRoomId(String roomId) {
		this.roomId = roomId;
	}
	public final String getSender() {
		return sender;
	}
	public final void setSender(String sender) {
		this.sender = sender;
	}
	public final String getMessage() {
		return message;
	}
	public final void setMessage(String message) {
		this.message = message;
	}

}
