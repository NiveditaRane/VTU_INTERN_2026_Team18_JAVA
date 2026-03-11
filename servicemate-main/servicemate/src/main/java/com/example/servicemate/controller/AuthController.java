package com.example.servicemate.controller;

import com.example.servicemate.entity.User;
import com.example.servicemate.dto.UserDTO;
import com.example.servicemate.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "http://localhost:5173")
public class AuthController {

    @Autowired
    private UserRepository userRepository;

    // --- SIGNUP ENDPOINT ---
    @PostMapping("/signup")
    public ResponseEntity<?> registerUser(@RequestBody UserDTO userDTO) {
        try {
            if (userRepository.existsByEmail(userDTO.getEmail())) {
                return ResponseEntity.badRequest().body("Error: Email is already in use!");
            }

            User user = new User();
            user.setName(userDTO.getName());
            user.setEmail(userDTO.getEmail());
            user.setPassword(userDTO.getPassword());
            user.setRole(userDTO.getRole().toLowerCase());
            user.setPhone(userDTO.getPhone());

            if ("provider".equalsIgnoreCase(userDTO.getRole())) {
                user.setServiceType(userDTO.getServiceType());
            }

            userRepository.save(user);
            return ResponseEntity.ok("User registered successfully!");

        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error: " + e.getMessage());
        }
    }

    // --- LOGIN ENDPOINT (Add this to fix the 404) ---
    @PostMapping("/login")
    public ResponseEntity<?> loginUser(@RequestBody UserDTO loginDTO) {
        try {
            // 1. Find the user by email
            Optional<User> userOptional = userRepository.findByEmail(loginDTO.getEmail());

            if (userOptional.isPresent()) {
                User user = userOptional.get();

                // 2. Check if password matches
                if (user.getPassword().equals(loginDTO.getPassword())) {
                    // Return the full user object (or a custom success message)
                    return ResponseEntity.ok(user);
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Error: Invalid password!");
                }
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Error: User not found!");
            }
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Error: " + e.getMessage());
        }
    }
}