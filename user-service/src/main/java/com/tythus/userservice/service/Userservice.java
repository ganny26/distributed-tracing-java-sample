package com.signoz.userservice.service;


import com.signoz.userservice.entity.Users;
import com.signoz.userservice.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class Userservice {

    private final UserRepository userRepository;

    public Userservice(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Optional<Users> findById(int id){
        return userRepository.findById(id);
    }

    public Users save(Users users){
        return userRepository.save(users);
    }

    public Users update(int id,Users users){
        Users userData = userRepository.findById(id).get();
        userData.setAmount(users.getAmount());
        userData.setStatus(users.getStatus());
        return userRepository.save(userData);
    }
}
