package com.tythus.orderservice.orderservice.controller;

import com.tythus.orderservice.orderservice.entity.Order;
import com.tythus.orderservice.orderservice.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/orders")
@CrossOrigin(origins = "*")
public class OrderController {

    @Autowired
    private OrderService orderService;

    @PostMapping(value = "/create/id/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Order> createOrder(@PathVariable(value = "id") int id,@RequestBody Order order) {
        Order orderResponse = orderService.save(id,order);
        return ResponseEntity.ok().body(orderResponse);
    }

}
