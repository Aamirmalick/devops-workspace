package com.aamirtechie.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1")
public class SampleController {

	@GetMapping(value = "/getServiceStatus")
	public String getStatus() {
		return "Service is  up & running ...";
	}
	
    private static final ThreadLocal<byte[]> threadLocal = new ThreadLocal<>();

    @GetMapping("/leak-threadlocal")
    public String leakThreadLocalMemory() {
        for(int i=0;i<=100000;i++) {
        	// Allocate a large byte array and store it in ThreadLocal
            threadLocal.set(new byte[1024 * 1024 * 10]); // 10MB
//            threadLocal.remove();
            
        }
    	// Not calling threadLocal.remove() after usage
        return "Leaking ThreadLocal Memory!";
    }

}
