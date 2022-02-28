package com.signoz.orderservice.orderservice.service;

import com.signoz.orderservice.orderservice.entity.User;
import com.signoz.orderservice.orderservice.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }


    public User save(User users){
        return userRepository.save(users);
    }


}