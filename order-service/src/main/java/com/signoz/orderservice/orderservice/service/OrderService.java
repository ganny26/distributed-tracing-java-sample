package com.signoz.orderservice.orderservice.service;

import com.signoz.orderservice.orderservice.domain.UsersDTO;
import com.signoz.orderservice.orderservice.entity.Order;
import com.signoz.orderservice.orderservice.entity.User;
import com.signoz.orderservice.orderservice.feign.UserFeignClient;
import com.signoz.orderservice.orderservice.feign.PaymentFeignClient;
import com.signoz.orderservice.orderservice.repository.OrderRepository;
import com.signoz.orderservice.orderservice.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Map;

@Service
public class OrderService {
    @Autowired
    private OrderRepository orderRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserFeignClient userFeignClient;

    @Autowired
    private PaymentFeignClient paymentFeignClient;

    @Autowired
    private UserService userService;


    public Order save(int id, Order order){
        User userResponse = userFeignClient.getUsersById(id).getBody();
        Order orderData = new Order();
        orderData.setAccount(userResponse.getAccount());
        orderData.setOrderStatus("order_placed");
        orderData.setProductName(order.getProductName());
        orderData.setPrice(order.getPrice());
        Integer balanceAmount = Integer.parseInt(userResponse.getAmount()) - Integer.parseInt(order.getPrice());
        userResponse.setAmount(String.valueOf(balanceAmount));

        // Paymentservice
        Map<String,String> paymentResponse = paymentFeignClient.getPaymentByIdAmount(2, "500").getBody();
        System.out.println(paymentResponse.toString());

        // Update existing user balance
        User data = userService.save(userResponse);
        return orderRepository.save(orderData);
    }
}
