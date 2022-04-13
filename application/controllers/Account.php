<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Account extends CI_Controller
{

    function index()
    {
        header('Content-Type: application/json');



        $email = $this->input->post('email');
        $password = $this->input->post('password');
        $login = $this->account->get(array("email" => $email, "password" => $password));
        $row = $login->row();

        if ($login->num_rows() == '1') {

            $t = strtotime($row->reg_date);

            $data = array(
                "email" => $row->email,
                "perusahaan" => $row->perusahaan,
                "name" => $row->name,
                "provinsi" => $row->propinsi,
                "kota" => $row->kota,
                "image" => $row->image,
                "tanggal_registrasi" => date('d-m-Y', $t),
            );
            echo json_encode($data);
        } else {
            $data = array(
                "email" => "",
                "perusahaan" => "",
                "name" => "",
                "provinsi" => "",
                "kota" => "",
                "image" => "",
                "tanggal_registrasi" => "",
            );
            echo json_encode($data);
        }
    }

    function login()
    {
        header('Content-Type: application/json');

        $email = $this->input->post('email');
        $password = $this->input->post('password');
        $login = $this->account->get(array("email" => $email, "password" => $password));
        $data = array("status" => $login->num_rows(), "message" => ($login->num_rows() == '0') ? 'Email dan password salah' : 'Login berhasil');
        echo json_encode($data);

        $dataHistory = array(
            "email" => $email,
            "tanggal" => date('Y-m-d h:i:s'),
        );

        $this->account->add_history($dataHistory);
    }

    function register()
    {
        header('Content-Type: application/json');

        $name = $this->input->post('name');
        $email = $this->input->post('email');
        $password = $this->input->post('password');
        $perusahaan = $this->input->post('perusahaan');
        $kota = $this->input->post('kota');
        $provinsi = $this->input->post('provinsi');

        $config['upload_path']          = './uploads/';
        $config['allowed_types']        = 'gif|jpg|jpeg|png';
        $this->load->library('upload', $config);

        $check = $this->account->get(array("email" => $email, "password" => $password))->num_rows();

        if ($check == '0') {
            if ($this->upload->do_upload('image')) {
                $image_data = $this->upload->data();
                $imagename = $this->upload->data('file_name');
            } else {
                echo $this->upload->display_errors();
            }

            $data = array(
                "name" => $name,
                "email" => $email,
                "password" => $password,
                "image" => $imagename,
                "perusahaan" => $perusahaan,
                "kota" => $kota,
                "propinsi" => $provinsi,
                "reg_date" => date('Y-m-d'),
            );

            $status = 1;
            $message = "Proses pendaftaran berhasil. Silahkan login";
            $login = $this->account->add($data);
        } else {
            $status = 0;
            $message = "Email sudah terdaftar";
        }

        $result = array(
            'status' => $status,
            'message' => $message
        );


        echo json_encode($result);
    }

    function password()
    {
        $email = $this->input->post('email');
        $password = $this->input->post('password');

        $data = array(
            "password" => $password,
        );

        $where = array(
            'email' => $email
        );

        $result = $this->account->update($where, $data, 'user_data');

        $result = array(
            'status' => $result == true ? 1 : 0,
            'message' => "Update profile berhasil"
        );


        echo json_encode($result);
    }

    function update()
    {
        $email = $this->input->post('email');
        $name = $this->input->post('name');
        $perusahaan = $this->input->post('perusahaan');
        $kota = $this->input->post('kota');
        $provinsi = $this->input->post('provinsi');

        $acc = $this->account->get(array("email" => $email))->row();

        $config['upload_path']          = './uploads/';
        $config['allowed_types']        = 'gif|jpg|jpeg|png';
        $this->load->library('upload', $config);

        if ($this->upload->do_upload('image')) {
            $image_data = $this->upload->data();
            $imagename = $this->upload->data('file_name');

            if ($acc->image != "default.png") {
                unlink(FCPATH . "uploads/" . $acc->image);
            }
        } else {
            echo $this->upload->display_errors();
        }

        $data = array(
            "name" => $name,
            "perusahaan" => $perusahaan,
            "kota" => $kota,
            "propinsi" => $provinsi,
            "image" => $imagename
        );

        $where = array(
            'email' => $email
        );

        $result = $this->account->update($where, $data, 'user_data');

        $result = array(
            'status' => $result == true ? 1 : 0,
            'message' => "Update profile berhasil"
        );


        echo json_encode($result);
    }
}
