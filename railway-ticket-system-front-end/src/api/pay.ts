import request from '@/utils/request';
import { type ApiResponse } from '@/types';

export interface PaymentSession {
  paymentId: string;
  orderId: number;
  expireAt: number;
}

export function createPayment(orderId: number) {
  return request.post<any, ApiResponse<PaymentSession>>('/pay/create', { orderId });
}

export function mockPaySuccess(orderId: number) {
  return request.post<any, ApiResponse<boolean>>('/pay/mock/success', { orderId });
}
