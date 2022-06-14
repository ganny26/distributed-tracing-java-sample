package com.tythus.orderservice.feign;


import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import java.util.Map;

@FeignClient(name="payment-service-old")
public interface PaymentFeignClient {

    // get payment details from paymentservice
    @RequestMapping(value = "/payment/transfer/id/{id}/amount/{amount}", method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,String>> getPaymentByIdAmount(@PathVariable int id, @PathVariable String amount);

}
