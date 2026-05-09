<template>
  <div class="pay-page">
    <el-card class="box">
      <h2>模拟支付</h2>
      <p>订单号：{{ orderId }}</p>
      <p>请在 <b>{{ mm }}:{{ ss }}</b> 内完成支付，否则将自动取消。</p>
      <div class="actions">
        <el-button type="primary" @click="onSuccess" :loading="loading">模拟支付成功</el-button>
        <el-button @click="goOrders">稍后再说</el-button>
        <el-button type="danger" @click="onCancel" :loading="canceling">取消订单</el-button>
      </div>
    </el-card>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, ref, computed } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { createPayment, mockPaySuccess } from '@/api/pay';
import { ElMessage } from 'element-plus';
import { orderApi } from '@/api/order';

const route = useRoute();
const router = useRouter();
const orderId = Number(route.query.orderId);
const expireAt = ref<number>(Date.now() + 15 * 60 * 1000);
const left = ref<number>(0);
const loading = ref(false);
const canceling = ref(false);

const mm = computed(() => String(Math.floor(left.value / 60000)).padStart(2, '0'));
const ss = computed(() => String(Math.floor((left.value % 60000) / 1000)).padStart(2, '0'));
let timer: any;

onMounted(async () => {
  try {
    const { data } = await createPayment(orderId);
    expireAt.value = data.expireAt;
    syncRemainingTime();
    if (left.value <= 0) {
      ElMessage.warning('订单已超时，请重新下单或前往订单页查看');
      await router.replace('/passenger/order');
      return;
    }
    tick();
  } catch (e: any) {
    ElMessage.error(e?.message || '创建支付失败');
    await router.replace('/passenger/order');
  }
});

function syncRemainingTime() {
  left.value = Math.max(0, expireAt.value - Date.now());
}

function tick() {
  clearInterval(timer);
  syncRemainingTime();
  timer = setInterval(() => {
    syncRemainingTime();
    if (left.value <= 0) {
      clearInterval(timer);
      ElMessage.warning('订单已超时，系统将自动取消');
      void router.push('/passenger/order');
    }
  }, 1000);
}

async function onSuccess() {
  try {
    syncRemainingTime();
    if (left.value <= 0) {
      ElMessage.warning('订单已超时，无法继续支付');
      await router.replace('/passenger/order');
      return;
    }
    loading.value = true;
    const res: Awaited<ReturnType<typeof mockPaySuccess>> = await mockPaySuccess(orderId);
    if (res.code === 200) {
      ElMessage.success('支付成功，已出票');
      await router.push('/passenger/order');
    } else {
      ElMessage.error(res.message || '支付失败');
      if (res.message?.includes('超时') || res.message?.includes('已支付') || res.message?.includes('当前订单状态')) {
        await router.replace('/passenger/order');
      }
    }
  } finally {
    loading.value = false;
  }
}

function goOrders() {
  void router.push('/passenger/order');
}

async function onCancel() {
  try {
    canceling.value = true;
    const res = await orderApi.cancelOrder(orderId);
    if (res.code === 200) {
      ElMessage.success('订单已取消');
      await router.push('/passenger/order');
    } else {
      ElMessage.error(res.message || '取消失败');
    }
  } finally {
    canceling.value = false;
  }
}

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<style scoped>
.pay-page { display:flex; justify-content:center; padding:40px; }
.box { width:520px; }
.actions { margin-top:16px; display:flex; gap:12px; }
</style>
