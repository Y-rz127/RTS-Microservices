// 通用响应类型
export interface ApiResponse<T = any> {
  code: number
  message: string
  data: T
}

// 用户相关
export interface User {
  userid: number
  username: string
  role: 'ADMIN' | 'OPERATOR' | 'PASSENGER'
  phone?: string
  status: number
  createTime?: string
  updateTime?: string
}

export interface LoginRequest {
  username: string
  password: string
}

export interface RegisterRequest {
  username: string
  password: string
  phone?: string
  role: 'ADMIN' | 'OPERATOR' | 'PASSENGER'
  status?: number
}

export interface LoginResponse {
  token: string
  user: User
}

// 车次相关
export interface Train {
  trainId: number
  trainNumber: string
  trainType: string
  totalSeats: number
  availableSeats?: number
  startStation: string
  endStation: string
  departureTime: string
  arrivalTime: string
  basePrice: number
  runningDays?: string
  status: number
  createdAt?: string
  updatedAt?: string
}

// 车站相关
export interface Station {
  stationId: number
  stationName: string
  city: string
  province?: string
  stationLevel: string
  address?: string
  contactPhone?: string
  status: number
  createdAt?: string
  updatedAt?: string
}

// 座位相关
export interface Seat {
  seatId: number
  trainId: number
  carriageNumber: string
  seatNumber: string
  seatType: string
  seatLevel?: number
  priceCoefficient?: number
  price?: number
  status: string
  createdAt?: string
  updatedAt?: string
}

// 车票相关
export interface Ticket {
  ticketId: number
  ticketNumber: string
  orderId: number
  trainId: number
  seatId: number
  passengerId: number
  sellerId?: number
  startStation: string
  endStation: string
  travelDate: string
  departureTime: string
  arrivalTime: string
  price: number
  status: string
  hadPay: number
  isPreBook: number
  refundFee?: number
  saleTime: string
  createdAt?: string
  updatedAt?: string
}

// 订单相关
export interface Order {
  orderId: number
  orderNumber: string
  userId: number
  totalAmount: number
  paymentAmount?: number
  orderType: string
  orderStatus: string
  paymentMethod?: string
  paymentTime?: string
  operatorId?: number
  remark?: string
  createdAt: string
  updatedAt?: string
}

// 路线相关
export interface Route {
  routeId: number
  trainId: number
  stationId: number
  stationName: string
  arrivalTime?: string
  departureTime?: string
  stopOrder: number
  stopDuration?: number
  distanceFromStart?: number
  additionalPrice: number
  createdAt?: string
  updatedAt?: string
}

// 乘客相关
export interface Passenger {
  passengerId: number
  userId?: number
  name: string
  idType: string
  idNumber: string
  phone: string
  email?: string
  gender?: string
  createdAt?: string
  updatedAt?: string
}

// 系统配置
export interface SystemConfig {
  configId: number
  configKey: string
  configValue: string
  configType: string
  description?: string
  isSystem: number
  status: number
  createdAt?: string
  updatedAt?: string
}

// 数据字典
export interface Dictionary {
  dictId: number
  dictType: string
  dictCode: string
  dictLabel: string
  dictValue: string
  sortOrder: number
  status: number
  remark?: string
  createdAt?: string
  updatedAt?: string
}

// 操作日志
export interface OperationLog {
  logId: number
  userId: number
  username: string
  operation: string
  module: string
  method?: string
  params?: string
  result?: string
  ipAddress: string
  executionTime?: number
  status: string
  errorMsg?: string
  createdAt: string
}

// 分页参数
export interface PageRequest {
  pageNum: number
  pageSize: number
}

// 分页响应
export interface PageResponse<T> {
  records: T[]
  total: number
  size: number
  current: number
  pages: number
}
