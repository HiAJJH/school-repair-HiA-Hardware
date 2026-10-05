-- ============================================================
-- 升级2：给服务加图标 + 增加电话/微信号/公告设置
-- 前提：已运行过「新增内容管理表.sql」
-- 在 Supabase → SQL Editor 粘贴整段运行一次
-- ============================================================

-- 服务表加图标字段
alter table public.services add column if not exists icon text;

-- 给默认服务补图标（已有图标的不会被覆盖）
update public.services set icon = '🧹' where name = '笔记本清灰' and icon is null;
update public.services set icon = '💻' where name = '系统重装/优化' and icon is null;
update public.services set icon = '⚡' where name = '硬件升级' and icon is null;
update public.services set icon = '♻️' where name = '二手回收' and icon is null;
update public.services set icon = '🛒' where name = '二手售卖' and icon is null;

-- 新增设置项：电话、微信号、公告
insert into public.settings (key, value) values
  ('phone', '18896094889'),
  ('wechat', 'HiATEAM'),
  ('notice', '')
on conflict (key) do nothing;
