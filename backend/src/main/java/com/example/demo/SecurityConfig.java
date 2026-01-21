package com.example.demo;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.annotation.web.configurers.HeadersConfigurer.FrameOptionsConfig;
import org.springframework.security.config.annotation.web.configurers.LogoutConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import static org.springframework.boot.security.autoconfigure.web.servlet.PathRequest.toH2Console;

@Configuration
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        // You can specify the strength (cost factor) here. Default is 10.
        return new BCryptPasswordEncoder(12);
    }

    @Bean
    UserDetailsService userDetailsService(PasswordEncoder encoder) {
        String password = encoder.encode("abc@123");
        UserDetails user = User.withUsername("user").password(password).roles("ADMIN").build();
        return new InMemoryUserDetailsManager(user);
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // Disabling CSRF protection for all requests (use with caution)
                .csrf(csrf -> csrf.disable())
                // Configure authorization
                .authorizeHttpRequests(authorize -> authorize
                        .anyRequest().permitAll() // Allow all requests (adjust as needed)
                ).headers(headers -> headers.frameOptions(FrameOptionsConfig::disable))

        ;
        return http.build();
    }

}