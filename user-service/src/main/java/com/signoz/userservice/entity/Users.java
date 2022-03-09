package com.signoz.userservice.entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "users_tbl")
@EntityListeners(AuditingEntityListener.class)
public class Users {



    @Id
    @GeneratedValue
    private int id;
    @Column(name = "user_name")
    private String userName;
    @Column(name = "account")
    private String account;
    @Column(name = "status",nullable = true)
    private String status;
    @Column(name = "amount",nullable = true)
    private String amount;
    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Date createdAt;
    @UpdateTimestamp
    @Column(name = "updated_at",nullable = true)
    private Date updatedAt;

}
