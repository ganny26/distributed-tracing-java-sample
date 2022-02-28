package com.signoz.paymentservice.feign;

import com.signoz.paymentservice.domain.Users;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Map;

@FeignClient(name="user-service")
public interface UserServiceClient {

    // get user details from userservice
    @RequestMapping(value = "/users/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,String>> getUsersById(@PathVariable int id);

    // update user details from userservice
    @RequestMapping(value = "/users/{id}",method = RequestMethod.PUT,produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Map<String,String>> updateUserById(@PathVariable int id, @RequestBody Users users);

}
