package com.ticket.userauth.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ticket.annotation.Log;
import com.ticket.model.entity.OperationLog;
import com.ticket.model.entity.User;
import com.ticket.model.request.LoginRequest;
import com.ticket.model.response.LoginResponse;
import com.ticket.model.response.Result;
import com.ticket.userauth.service.OperationLogService;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.lang.reflect.Method;
import java.util.Date;

@Aspect
@Component
public class OperationLogAspect {

    @Resource
    private OperationLogService operationLogService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Pointcut("@annotation(com.ticket.annotation.Log)")
    public void logPointcut() {}

    @Around("logPointcut()")
    public Object around(ProceedingJoinPoint joinPoint) throws Throwable {
        long startTime = System.currentTimeMillis();

        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        Method method = signature.getMethod();
        Log logAnnotation = method.getAnnotation(Log.class);

        OperationLog operationLog = new OperationLog();
        operationLog.setModule(logAnnotation.module());
        operationLog.setOperation(logAnnotation.operation());
        operationLog.setMethod(signature.getDeclaringTypeName() + "." + method.getName());
        operationLog.setCreatedAt(new Date());

        try {
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                operationLog.setIpAddress(getClientIp(request));
            }
        } catch (Exception e) {
            operationLog.setIpAddress("unknown");
        }

        fillUserFromAuthentication(operationLog);
        fillUserFromArgs(joinPoint.getArgs(), operationLog);

        if (logAnnotation.saveParams()) {
            try {
                Object[] args = joinPoint.getArgs();
                if (args != null && args.length > 0) {
                    String params = objectMapper.writeValueAsString(args);
                    if (params.length() > 2000) {
                        params = params.substring(0, 2000) + "...";
                    }
                    operationLog.setParams(params);
                }
            } catch (Exception e) {
                operationLog.setParams("参数序列化失败");
            }
        }

        Object result;
        try {
            result = joinPoint.proceed();
            operationLog.setStatus("SUCCESS");
            fillUserFromResult(result, operationLog);
            if (logAnnotation.saveResult() && result != null) {
                try {
                    String resultStr = objectMapper.writeValueAsString(result);
                    if (resultStr.length() > 2000) {
                        resultStr = resultStr.substring(0, 2000) + "...";
                    }
                    operationLog.setResult(resultStr);
                } catch (Exception e) {
                    operationLog.setResult("结果序列化失败");
                }
            }
            return result;
        } catch (Throwable e) {
            operationLog.setStatus("FAILURE");
            operationLog.setErrorMsg(e.getMessage());
            throw e;
        } finally {
            long executionTime = System.currentTimeMillis() - startTime;
            operationLog.setExecutionTime((int) executionTime);
            operationLogService.saveLog(operationLog);
        }
    }

    private void fillUserFromAuthentication(OperationLog operationLog) {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null) {
                return;
            }
            Object principal = authentication.getPrincipal();
            if (principal instanceof User user) {
                operationLog.setUserId(user.getUserid());
                operationLog.setUsername(user.getUsername());
            } else if (principal instanceof String userIdStr) {
                if ("anonymousUser".equals(userIdStr)) {
                    return;
                }
                try {
                    int userId = Integer.parseInt(userIdStr);
                    operationLog.setUserId(userId);
                    User user = operationLogService.getUserById(userId);
                    operationLog.setUsername(user != null ? user.getUsername() : userIdStr);
                } catch (NumberFormatException e) {
                    operationLog.setUsername(userIdStr);
                }
            } else if (authentication.getName() != null && !"anonymousUser".equals(authentication.getName())) {
                operationLog.setUsername(authentication.getName());
            }
        } catch (Exception e) {
            if (operationLog.getUsername() == null || operationLog.getUsername().isBlank()) {
                operationLog.setUsername("anonymous");
            }
        }
    }

    private void fillUserFromArgs(Object[] args, OperationLog operationLog) {
        if (args == null || args.length == 0) {
            return;
        }
        for (Object arg : args) {
            if (arg instanceof LoginRequest loginRequest) {
                String username = loginRequest.getUsername();
                if (username != null && !username.isBlank()) {
                    operationLog.setUsername(username.trim());
                }
                return;
            }
        }
    }

    private void fillUserFromResult(Object result, OperationLog operationLog) {
        if (!(result instanceof Result<?> resultWrapper) || !resultWrapper.isSuccess()) {
            return;
        }
        Object data = resultWrapper.getData();
        if (data instanceof LoginResponse loginResponse && loginResponse.getUser() != null) {
            User user = loginResponse.getUser();
            operationLog.setUserId(user.getUserid());
            operationLog.setUsername(user.getUsername());
        }
    }

    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        return ip;
    }
}
