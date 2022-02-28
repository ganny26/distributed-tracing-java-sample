package com.signoz.orderservice.orderservice.domain;


import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class UsersDTO {
    @JsonProperty("id")
    private int id;
    @JsonProperty("userName")
    private String userName;
    @JsonProperty("account")
    private String account;
    @JsonProperty("status")
    private String status;
    @JsonProperty("amount")
    private String amount;
    @JsonProperty("created_at")
    private Date createdAt;
    @JsonProperty("updated_at")
    private Date updatedAt;
}