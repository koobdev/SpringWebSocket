package com.Kcompany.Kboard.socket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
@ComponentScan("com.Kcompany.Kboard.socket")

public class WebSocketConfig implements WebSocketConfigurer{
	
	@Autowired
	private WebSocketHandler websocketHandler;
	
	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		// TODO Auto-generated method stub
		registry.addHandler(websocketHandler, "/chat").setAllowedOrigins("*").withSockJS();
	}

}



