drop table if exists flight_data;
drop table if exists start_parameters;
drop table if exists real_flights_info;
drop table if exists flights;
drop table if exists vehicles;
drop table if exists trajectories_parameters;

set datestyle = mdy;

create table flights(
    flight_id serial primary key,
--     flight_date date,
    log_name varchar(100),
    flight_type varchar(100),

    check (flight_type in ('real', 'simulation'))
);


create table flight_data(

    id serial primary key,
    flight_id integer,
    time_s float,
    x float,
    y float,
    z float,
    v_cmd float,
    w_cmd float,


    foreign key (flight_id) references flights(flight_id)
);


create table trajectories_parameters(
    trajectory_id serial primary key,
    center_x float,
    center_y float,
    radius float,
    height float
);

create table vehicles(
    name varchar(100) primary key,
    mass float
);

create table start_parameters(
    flight_id integer,
    trajectory_id integer,
    target_speed float,
    vertical_speed float,

    foreign key (flight_id) references flights(flight_id),
    foreign key (trajectory_id) references trajectories_parameters(trajectory_id)
);

create table real_flights_info(
    flight_id integer,
    vehicle varchar(100),
    pilot varchar(100),

    foreign key (flight_id) references flights(flight_id),
    foreign key (vehicle) references vehicles(name)
);

insert into vehicles(mass, name) values
    (250, 'Dart250');

insert into trajectories_parameters(center_x, center_y, radius, height) values
    (0, 0, 130.0, 100.0),
    (0, -50, 150.0, 100.0),
    (0, 0, 100.0, 100.0);




