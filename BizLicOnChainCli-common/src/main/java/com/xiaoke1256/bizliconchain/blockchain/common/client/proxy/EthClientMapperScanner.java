package com.xiaoke1256.bizliconchain.blockchain.common.client.proxy;

import java.util.Arrays;
import java.util.Iterator;
import java.util.Objects;
import java.util.Set;

import org.springframework.beans.factory.annotation.AnnotatedBeanDefinition;
import org.springframework.beans.factory.config.BeanDefinitionHolder;
import org.springframework.beans.factory.support.BeanDefinitionRegistry;
import org.springframework.beans.factory.support.GenericBeanDefinition;
import org.springframework.context.annotation.ClassPathBeanDefinitionScanner;
import org.springframework.core.type.filter.AnnotationTypeFilter;
import org.springframework.util.ClassUtils;

import com.xiaoke1256.bizliconchain.blockchain.common.client.annotation.EthClient;

public class EthClientMapperScanner extends ClassPathBeanDefinitionScanner {
    private ClassLoader classLoader;

    public EthClientMapperScanner(BeanDefinitionRegistry registry, ClassLoader classLoader) {
        super(registry, false);
        this.classLoader = classLoader;
        this.addIncludeFilter(new AnnotationTypeFilter(EthClient.class));
    }

    protected boolean isCandidateComponent(AnnotatedBeanDefinition beanDefinition) {
        if (beanDefinition.getMetadata().isInterface()) {
            try {
                Class<?> target = ClassUtils.forName(beanDefinition.getMetadata().getClassName(), this.classLoader);
                return !target.isAnnotation();
            } catch (Exception ex) {
                this.logger.error("load class exception:", ex);
            }
        }

        return false;
    }

    protected Set<BeanDefinitionHolder> doScan(String... basePackages) {
        Set<BeanDefinitionHolder> beanDefinitions = super.doScan(basePackages);
        if (beanDefinitions.isEmpty()) {
            this.logger.warn("No @EthClient was found in '" + Arrays.toString(basePackages) + "' package. Please check your configuration.");
        } else {
            this.processBeanDefinitions(beanDefinitions);
        }

        return beanDefinitions;
    }

    private void processBeanDefinitions(Set<BeanDefinitionHolder> beanDefinitions) {
        Iterator<BeanDefinitionHolder> iter = beanDefinitions.iterator();

        while(iter.hasNext()) {
            BeanDefinitionHolder holder = (BeanDefinitionHolder)iter.next();
            GenericBeanDefinition definition = (GenericBeanDefinition)holder.getBeanDefinition();
            if (this.logger.isDebugEnabled()) {
                this.logger.debug("Creating EthClientBean with name '" + holder.getBeanName() + "' and '" + definition.getBeanClassName() + "' Interface");
            }

       
            definition.getConstructorArgumentValues().addGenericArgumentValue(Objects.requireNonNull(definition.getBeanClassName()));
            definition.setBeanClass(EthClientFactoryBean.class);
        }

    }
}