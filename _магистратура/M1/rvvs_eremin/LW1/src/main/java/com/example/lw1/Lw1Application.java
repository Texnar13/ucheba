package com.example.lw1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;


@EnableJpaRepositories("com.example.lw1")
@EntityScan("com.example.lw1")
@ComponentScan(basePackages = { "com.example.lw1" })
@SpringBootApplication
public class Lw1Application {
    public static void main(String[] args) {
        SpringApplication.run(Lw1Application.class, args);
    }
}
