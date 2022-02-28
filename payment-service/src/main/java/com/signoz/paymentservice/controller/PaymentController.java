package com.signoz.paymentservice.controller;


import com.signoz.paymentservice.domain.Users;
import com.signoz.paymentservice.feign.UserServiceClient;
import io.opentelemetry.api.GlobalOpenTelemetry;
import io.opentelemetry.api.OpenTelemetry;
import io.opentelemetry.api.trace.Span;
import io.opentelemetry.api.trace.StatusCode;
import io.opentelemetry.api.trace.Tracer;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import io.opentelemetry.api.OpenTelemetry;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/payment")
public class PaymentController {
    private final Logger LOGGER = LoggerFactory.getLogger(PaymentController.class);
    private static final Tracer tracer =
            GlobalOpenTelemetry.getTracer("com.signoz.paymentservice");

    @Autowired
    private UserServiceClient userServiceClient;

    @GetMapping(value = "/transfer/id/{id}/amount/{amount}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,String>> getUserById(@PathVariable("id") int id,@PathVariable("amount") String amount){
        try {
            //ResponseEntity<Map<String,String>> response = userServiceClient.getUsersById(id);
            Users users = new Users();
            users.setId(id);
            users.setAmount(amount);
            users.setStatus("success");
            ResponseEntity<Map<String,String>> response = userServiceClient.updateUserById(id,users);
            return ResponseEntity.ok().body(response.getBody());
        }catch (Exception e){
            HashMap<String,String> result = new HashMap<>();
            result.put("message",e.getMessage());
            Span childSpan = tracer.spanBuilder("payment-service").startSpan();
            childSpan.recordException(new RuntimeException("UsersService down"));
            childSpan.setStatus(StatusCode.ERROR);
            return ResponseEntity.ok().body(result);
        }

    }
}
