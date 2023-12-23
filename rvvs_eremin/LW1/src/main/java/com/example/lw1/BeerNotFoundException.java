package com.example.lw1;

public class BeerNotFoundException extends Throwable {
    BeerNotFoundException(Long id) {
        super("Could not find beer " + id);
    }
}