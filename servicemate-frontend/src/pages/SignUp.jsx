import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { User, Mail, Lock, Phone, Briefcase, ArrowRight, ShieldCheck, ChevronDown, Eye, EyeOff } from 'lucide-react';
import { useNavigate, Link } from 'react-router-dom';
import LiveBackground from '../components/LiveBackground';
import axios from 'axios';
import toast from 'react-hot-toast';

const SignUp = () => {
  const navigate = useNavigate();
  const [showPass, setShowPass] = useState(false);
  const [form, setForm] = useState({ name: '', email: '', password: '', role: 'customer', phone: '', serviceType: '' });

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://localhost:8080/api/auth/signup', form);
      toast.success("Account created successfully!");
      navigate('/login');
    } catch (err) {
      toast.error(err.response?.data || "Signup failed");
    }
  };

  return (
    <LiveBackground>
      <div className="flex min-h-screen">
        <div className="glass-sidebar">
          <motion.div initial={{ x: -20, opacity: 0 }} animate={{ x: 0, opacity: 1 }} className="space-y-6">
            <div className="w-14 h-14 bg-indigo-600 rounded-2xl flex items-center justify-center shadow-2xl shadow-indigo-500/40">
              <ShieldCheck className="text-white" size={28} />
            </div>
            <h1 className="text-4xl font-black tracking-tighter text-white">ServiceMate</h1>
            <p className="text-slate-400 text-lg">The future of professional services.</p>
          </motion.div>
        </div>

        <div className="flex-1 flex flex-col justify-center items-center p-8">
          <motion.div initial={{ y: 20, opacity: 0 }} animate={{ y: 0, opacity: 1 }} className="w-full max-w-md space-y-8">
            <div className="text-center">
              <h2 className="text-4xl font-bold">Get Started</h2>
              <p className="text-slate-500">Create your ServiceMate profile</p>
            </div>

            <div className="flex gap-4 p-1 bg-white/5 rounded-2xl border border-white/5">
              {['customer', 'provider'].map(r => (
                <button key={r} type="button" onClick={() => setForm({...form, role: r})}
                  className={`flex-1 py-3 rounded-xl font-bold transition-all capitalize ${form.role === r ? 'bg-indigo-600 text-white shadow-lg shadow-indigo-600/20' : 'text-slate-500 hover:text-white'}`}>
                  {r}
                </button>
              ))}
            </div>

            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="premium-input-wrapper"><User className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-hover:text-indigo-400" size={20} />
                <input className="premium-input" placeholder="Full Name" onChange={e => setForm({...form, name: e.target.value})} required />
              </div>

              <AnimatePresence>
                {form.role === 'provider' && (
                  <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: 'auto', opacity: 1 }} exit={{ height: 0, opacity: 0 }}>
                    <div className="premium-input-wrapper mb-4">
                      <Briefcase className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-hover:text-indigo-400" size={20} />
                      <select className="premium-input appearance-none cursor-pointer" onChange={e => setForm({...form, serviceType: e.target.value})} required>
                        <option value="" disabled selected className="bg-[#0a0a0c]">Select Specialty</option>
                        <option value="plumbing" className="bg-[#0a0a0c]">🚰 Plumbing</option>
                        <option value="electrical" className="bg-[#0a0a0c]">⚡ Electrical</option>
                        <option value="cleaning" className="bg-[#0a0a0c]">🧹 Cleaning</option>
                        <option value="painting" className="bg-[#0a0a0c]">🎨 Painting</option>
                        <option value="carpentry" className="bg-[#0a0a0c]">🪑 Carpentry</option>
                        <option value="appliance" className="bg-[#0a0a0c]">🛠️ Appliance Repair</option>
                      </select>
                      <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 pointer-events-none" size={20} />
                    </div>
                  </motion.div>
                )}
              </AnimatePresence>

              <div className="premium-input-wrapper"><Mail className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-hover:text-indigo-400" size={20} />
                <input className="premium-input" type="email" placeholder="Email Address" onChange={e => setForm({...form, email: e.target.value})} required />
              </div>

              <div className="premium-input-wrapper"><Lock className="absolute left-4 top-1/2 -translate-y-1/2 text-slate-500 group-hover:text-indigo-400" size={20} />
                <input className="premium-input" type={showPass ? "text" : "password"} placeholder="Password" onChange={e => setForm({...form, password: e.target.value})} required />
                <button type="button" onClick={() => setShowPass(!showPass)} className="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-white">
                  {showPass ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>

              <button type="submit" className="btn-glow">Create Account <ArrowRight size={20} /></button>
            </form>
            <p className="text-center text-slate-500">Already have an account? <Link to="/login" className="text-indigo-400 font-bold hover:underline">Sign In</Link></p>
          </motion.div>
        </div>
      </div>
    </LiveBackground>
  );
};
export default SignUp;