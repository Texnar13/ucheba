package com.example.lw1;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BeerRepo extends JpaRepository<Beer, Long> {

    /*
     * @Query("SELECT * FROM Product WHERE name LIKE :x") public Page<Product>
     * findProduct(@Param("x") String keyWord, Pageable pageable);
     */
}

