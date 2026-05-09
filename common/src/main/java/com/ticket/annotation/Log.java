package com.ticket.annotation;

import java.lang.annotation.*;

/**
 * 操作日志注解，用于标记需要记录操作日志的方法。
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented //将该注解的信息记录在 JavaDoc 文档中。
public @interface Log {
    
    /**
     * 模块名称。
     */
    String module() default "";
    
    /**
     * 操作类型。
     */
    String operation() default "";
    
    /**
     * 是否记录请求参数。
     */
    boolean saveParams() default true;
    
    /**
     * 是否记录返回结果。
     */
    boolean saveResult() default false;
}
