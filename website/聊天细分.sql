-- 聊天细分：给消息表加"会话ID"字段（区分不同客户）
-- 在 Supabase → SQL Editor 粘贴运行一次即可
alter table public.messages add column if not exists conversation_id text;

-- 清掉没有会话ID的旧消息（避免显示异常）
delete from public.messages where conversation_id is null or conversation_id = '';
