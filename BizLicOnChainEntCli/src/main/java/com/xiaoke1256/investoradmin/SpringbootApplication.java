package com.xiaoke1256.investoradmin;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClientScan;

@EnableScheduling
@SpringBootApplication(scanBasePackages= {"com.xiaoke1256.bizliconchain","com.xiaoke1256.investoradmin"},exclude={HibernateJpaAutoConfiguration.class})
@EnableAutoConfiguration
@MapperScan("com.xiaoke1256.**.dao")
@EthClientScan("com.xiaoke1256.investoradmin.blockchain.cli")
public class SpringbootApplication extends SpringBootServletInitializer {
	
	@Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(SpringbootApplication.class);
    }
	
	public static void main(String[] args) {
        SpringApplication.run(SpringbootApplication.class, args);
    }
	
	
}
