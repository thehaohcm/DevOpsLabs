package person.haonguyen.rabbitmq.demo.publisher;

import java.util.UUID;

import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import person.haonguyen.rabbitmq.demo.config.MessageConfig;
import person.haonguyen.rabbitmq.demo.dto.Order;
import person.haonguyen.rabbitmq.demo.dto.OrderStatus;

@RestController
@RequestMapping("/order")
public class OrderPublisher {
	@Autowired
	private RabbitTemplate template;

	@PostMapping("/{restaurantName}")
	public String bookOrder(@RequestBody Order order,@PathVariable String restaurantName){
		order.setOrderId(UUID.randomUUID().toString());
		OrderStatus status=new OrderStatus(order,"PROCCESS","order has been placed successfully in "+restaurantName);
		template.convertAndSend(MessageConfig.exchange, MessageConfig.routingKey,status);
		return "Success!!";
	}

	@GetMapping
	public String sayHello(){
		return "hello";
	}
}
