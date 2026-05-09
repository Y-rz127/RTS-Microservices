import request from '@/utils/request'

// 获取热点车次排行榜
export function getHotTrainRanking(topN: number = 10, travelDate?: string, forceRefresh: boolean = false) {
  return request({
    url: '/hot/ranking',
    method: 'get',
    params: { topN, travelDate, forceRefresh }
  })
}

// 按日期查询热点车次
export function getHotTrainsByDate(travelDate: string) {
  return request({
    url: '/hot/by-date',
    method: 'get',
    params: { travelDate }
  })
}

// 查询车次座位布局详情
export function getSeatAvailability(trainId: number, travelDate: string) {
  return request({
    url: `/hot/seats`,
    method: 'get',
    params: { trainId, travelDate }
  })
}
