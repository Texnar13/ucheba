package com.example.lw1;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import org.springframework.stereotype.Component;

import java.io.Serial;
import java.io.Serializable;
import java.util.Objects;

@Entity
//@Table(name = "BEER")
@Component
public class Beer implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    //@Column(name="_id")
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private String name;
    private String country;
    private int cost;
    private String advantages;
    private String disadvantages;

    public Beer() {
        super();
    }

    public Beer(String name, String country, int cost, String advantages, String disadvantages) {
        this.name = name;
        this.country = country;
        this.cost = cost;
        this.advantages = advantages;
        this.disadvantages = disadvantages;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public int getCost() {
        return cost;
    }

    public void setCost(int cost) {
        this.cost = cost;
    }

    public String getAdvantages() {
        return advantages;
    }

    public void setAdvantages(String advantages) {
        this.advantages = advantages;
    }

    public String getDisadvantages() {
        return disadvantages;
    }

    public void setDisadvantages(String disadvantages) {
        this.disadvantages = disadvantages;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o)
            return true;
        if (!(o instanceof Beer comparableBeer))
            return false;
        return Objects.equals(this.id, comparableBeer.id) &&
                Objects.equals(this.name, comparableBeer.name) &&
                Objects.equals(this.country, comparableBeer.country) &&
                Objects.equals(this.cost, comparableBeer.cost) &&
                Objects.equals(this.advantages, comparableBeer.advantages) &&
                Objects.equals(this.disadvantages, comparableBeer.disadvantages);
    }

    @Override
    public int hashCode() {
        return Objects.hash(this.id,
                this.name,
                this.country,
                this.cost,
                this.advantages,
                this.disadvantages);
    }

    @Override
    public String toString() {
        return "Beer{" +
                "id=" + this.id + ", " +
                "name='" + this.name + "', " +
                "country='" + this.country + "', " +
                "cost=" + this.cost + ", " +
                "advantages='" + this.advantages + "', " +
                "disadvantages='" + this.disadvantages + "', " +
                '}';
    }
}


