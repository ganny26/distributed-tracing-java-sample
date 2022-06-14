package com.tythus.orderservice.service;

import com.tythus.orderservice.entity.User;
import com.tythus.orderservice.repository.UserRepository;
import org.springframework.stereotype.Service;

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