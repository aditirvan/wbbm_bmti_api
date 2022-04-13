<?php
class Mod_account extends CI_Model
{
    function get($where)
    {
        return $this->db->get_where('user_data', $where);
    }

    function add($data)
    {
        return $this->db->insert('user_data', $data);
    }

    function update($where, $data, $table)
    {
        $this->db->where($where);
        return $this->db->update($table, $data);
    }

    function add_history($data)
    {
        return $this->db->insert('login_history', $data);
    }
}
