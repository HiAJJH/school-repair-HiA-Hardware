-- 开启实时刷新：让管理端能实时收到新预约（运行一次即可）
-- 如果报错说"已在发布中"，说明已经开启过了，不用管。
alter publication supabase_realtime add table public.orders;
