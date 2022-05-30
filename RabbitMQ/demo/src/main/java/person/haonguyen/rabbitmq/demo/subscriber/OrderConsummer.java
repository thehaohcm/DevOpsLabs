package person.haonguyen.rabbitmq.demo.subscriber;

import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.stereotype.Component;

import person.haonguyen.rabbitmq.demo.config.MessageConfig;
import person.haonguyen.rabbitmq.demo.dto.OrderStatus;

@Component
public class OrderConsummer {
	
	@RabbitListener(queues=MessageConfig.queue)
	public void consumeOder(OrderStatus status){
		System.out.println("Message from queue: "+status);
	}
}
