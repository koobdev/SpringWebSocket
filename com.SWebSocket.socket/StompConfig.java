package com.Kcompany.Kboard.socket;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class StompConfig implements WebSocketMessageBrokerConfigurer {

	@Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        //메세지 브로커가 /sub 에 들어가는 구독자들에게 메세지를 전달해준다.
		config.enableSimpleBroker("/sub");
		//구독자가 서버에게 /pub를 붙여 메세지를 전달한다.
        config.setApplicationDestinationPrefixes("/pub");
    }
	
    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
    	// STOMP는 SockJS위에서 돌아간다. withSockJS()를 붙여준다.
        registry.addEndpoint("/stomp").setAllowedOrigins("*").withSockJS();
    }
    
    
}
