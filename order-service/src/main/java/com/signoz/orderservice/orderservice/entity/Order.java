package com.signoz.orderservice.orderservice.entity;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "orders_tbl")
@EntityListeners(AuditingEntityListener.class)
public class Order {


    @Id
    @GeneratedValue
    private int id;
    @Column(name = "account")
    private String account;
    @Column(name = "product_name",nullable = true)
    private String productName;
    @Column(name = "price",nullable = true)
    private String price;
    @Column(name = "order_status",nullable = true)
    private String orderStatus;
    @CreationTimestamp
    @Column(name = "created_at", nullable = true, updatable = false)
    private Date createdAt;
    @UpdateTimestamp
    @Column(name = "updated_at",nullable = true)
    private Date updatedAt;

}
