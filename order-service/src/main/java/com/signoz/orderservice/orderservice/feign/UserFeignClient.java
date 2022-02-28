package com.signoz.orderservice.orderservice.feign;


import com.signoz.orderservice.orderservice.domain.UsersDTO;
import com.signoz.orderservice.orderservice.entity.User;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.Map;

@FeignClient(name="user-service")
public interface UserFeignClient {

    // get user details from userservice
    @RequestMapping(value = "/users/{id}",method = RequestMethod.GET,produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<User> getUsersById(@PathVariable int id);

}
