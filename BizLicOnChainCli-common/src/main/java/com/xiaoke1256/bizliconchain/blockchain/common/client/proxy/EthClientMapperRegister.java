package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.util.Collections;
import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.BeanClassLoaderAware;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.context.ResourceLoaderAware;
import org.springframework.context.annotation.ImportBeanDefinitionRegistrar;
import org.springframework.core.annotation.AnnotationAttributes;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.type.AnnotationMetadata;
import org.springframework.util.ClassUtils;
import org.springframework.util.StringUtils;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClientScan;

public class EthClientMapperRegister implements ImportBeanDefinitionRegistrar, ResourceLoaderAware, BeanClassLoaderAware {
    private ClassLoader classLoader;
    private ResourceLoader resourceLoader;

    public void registerBeanDefinitions(AnnotationMetadata importingClassMetadata, BeanDefinitionRegistry registry) {
        AnnotationAttributes attributes = AnnotationAttributes.fromMap(importingClassMetadata.getAnnotationAttributes(EthClientScan.class.getName(), true));
        Set<String> packages = new HashSet<>();
        if (attributes != null) {
            this.addPackages(packages, attributes.getStringArray("value"));
            this.addPackages(packages, attributes.getStringArray("basePackages"));
            this.addClasses(packages, attributes.getStringArray("basePackageClasses"));
            if (packages.isEmpty()) {
                packages.add(ClassUtils.getPackageName(importingClassMetadata.getClassName()));
            }
        }

        EthClientMapperScanner scanner = new EthClientMapperScanner(registry, this.classLoader);
        if (this.resourceLoader != null) {
            scanner.setResourceLoader(this.resourceLoader);
        }

        scanner.doScan(StringUtils.toStringArray(packages));
    }

    private void addPackages(Set<String> packages, String[] values) {
        if (values != null) {
            Collections.addAll(packages, values);
        }
    }

    private void addClasses(Set<String> packages, String[] values) {
        if (values != null) {
            String[] newNalues = values;
            int length = values.length;

            for(int i = 0; i < length; ++i) {
                String value = newNalues[i];
                packages.add(ClassUtils.getPackageName(value));
            }
        }

    }

    public void setBeanClassLoader(ClassLoader classLoader) {
        this.classLoader = classLoader;
    }

    public void setResourceLoader(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }
}