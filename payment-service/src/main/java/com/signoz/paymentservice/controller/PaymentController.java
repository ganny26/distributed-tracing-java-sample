package com.signoz.paymentservice.controller;


import com.signoz.paymentservice.domain.Users;
import com.signoz.paymentservice.feign.UserServiceClient;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/payment")
@CrossOrigin(origins = "*")
public class PaymentController {
    private final Logger LOGGER = LoggerFactory.getLogger(PaymentController.class);
    @Autowired
    private UserServiceClient userServiceClient;

    @GetMapping(value = "/transfer/id/{id}/amount/{amount}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,String>> getUserById(@PathVariable("id") int id,@PathVariable("amount") String amount){
        try {
            Users users = new Users();
            users.setId(id);
            users.setAmount(amount);
            users.setStatus("success");
            ResponseEntity<Map<String,String>> response = userServiceClient.updateUserById(id,users);
            return ResponseEntity.ok().body(response.getBody());


        }catch (Exception e){
            HashMap<String,String> result = new HashMap<>();
            result.put("message",e.getMessage());
            return ResponseEntity.ok().body(result);
        }

    }
}
