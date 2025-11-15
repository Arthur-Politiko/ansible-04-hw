# ansible-04-hw
# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

# Решение

## Задание 1

### Из особенностей

Запуск playbook - это боль. `tags` не работает для `play`, `when` не работает для `play` и статического импорта, `play` нельзя включать внутри `task`, самый безболезненный способ оказался просто физически разнести `play` по файлам. И это печально.


Удаление clickhouse: 

`ansible-playbook -i inventory/prod.yml  "clickhouse_remove_all=true, clickhouse_remove=true" clickhouse.yml`

Ansible конкатенирует списки с помощью оператора +
Ну и прикольно добавляем свои адреса в список адресов clickhouse:
```
- name: Determine listen IP 
  set_fact:
    clickhouse_listen_host_custom: "{{ clickhouse_listen_host_custom + ansible_all_ipv4_addresses  }}"
```



## Задание 2

## Задание 3

## Задание 4

## Задание 5

## Задание 6

## Задание 7

## Задание 8

## Задание 9

Вытягиваем роли:
 ansible-galaxy install -r requirements.yml -p roles/





 
 